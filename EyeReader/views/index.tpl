<html>
    <title>Eyes Reader</title>
    <meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="/static/css/index.css" type="text/css" media="screen" />

    <style type="text/css">
    #box{
        width:500px;
        max-width: 100%;
        overflow: hidden;
        background-color: blue;
    }
    </style>
    <head></head>
    <body>
        <input type='file' id="input-image" name="original"/>
        <div id="box">
            <img id="photo" src="#"/>
        </div>
        
        <input type="hidden" id="user_id" value=""/>
        <input type="hidden" id="quiz_id" value="">
        <input type="text" id="slide_answer"/>
        <input type="button" id="btn_upload" value="Upload"/>
        <input type="button" id="btn_complete" value="Complete"/>

        <div>
            <canvas id="myCanvas">
            </canvas>
        </div>
        <div class="panel"></div>

        <script type="text/javascript" src="/static/js/jquery-2.1.4.min.js"></script>
        <script type="text/javascript" src="/static/js/hammer.min.js"></script>
        <script type="text/javascript" src="/static/js/filer.js"></script>
        <script type="text/javascript">
        imageObj = new Image();

        function readURL(input) {

            if (input.files && input.files[0]) {
                var reader = new FileReader();

                reader.onload = function (e) {
                    $('#photo').attr('src', e.target.result);
                    imageObj.src = e.target.result;
                    
                    var myElement = document.getElementById('photo');
                    var $photo = $('#photo');
                    var $box = $("#box");

                    var mc = new Hammer(myElement);
                    var press = new Hammer.Press({time: 1});
                    var pinch = new Hammer.Pinch();
                    var rotate = new Hammer.Rotate();
                    pinch.recognizeWith(rotate);
                    mc.add([press, pinch, rotate]);
                    mc.get('pan').set({ direction: Hammer.DIRECTION_ALL });

                    var margin_left = 0;
                    var margin_top = 0;
                    var image_width = parseFloat($photo.css("width"));
                    var image_height = parseFloat($photo.css("height"));
                    transform(margin_left, margin_top, image_width, image_height);

                    function prepairPosition() {
                        margin_left = parseFloat($photo.css("margin-left"));
                        margin_top = parseFloat($photo.css("margin-top"));
                        image_width = parseFloat($photo.css("width"));
                        image_height = parseFloat($photo.css("height"));
                    }

                    mc.on("press", function(event){
                        prepairPosition();
                    });

                    mc.on("panleft panright panup pandown", function(event) {
                        pointer = event.pointers[0];
                        transform(margin_left + event.deltaX,
                                  margin_top + event.deltaY,
                                  image_width,
                                  image_height);
                    });

                    var origin_distance = 0;
                    mc.on("pinchstart pinchend", function(event) {
                        pointer1 = event.pointers[0];
                        pointer2 = event.pointers[1];
                        origin_distance = Math.sqrt(
                            Math.pow(pointer1.clientX - pointer2.clientX, 2) +
                            Math.pow(pointer1.clientY - pointer2.clientY, 2)
                        );
                        prepairPosition();
                    });

                    mc.on("pinch", function(event) {
                        pointer1 = event.pointers[0];
                        pointer2 = event.pointers[1];
                        distance = Math.sqrt(
                            Math.pow(pointer1.clientX - pointer2.clientX, 2) +
                            Math.pow(pointer1.clientY - pointer2.clientY, 2)
                        );
                        multiple = distance / origin_distance;
                        new_width = image_width * multiple;
                        new_height = image_height * multiple;
                        transform(margin_left, margin_top, new_width, new_height);
                    });

                    var origin_vector = [0, 0];
                    mc.on("rotatestart", function(event) {
                        pointer1 = event.pointers[0];
                        pointer2 = event.pointers[1];
                        origin_vector = [pointer2.clientX - pointer1.clientX,
                                         pointer2.clientY - pointer1.clientY];
                    });

                    mc.on("rotate", function(event) {
                        pointer1 = event.pointers[0];
                        pointer2 = event.pointers[1];
                        vector = [pointer2.clientX - pointer1.clientX,
                                  pointer2.clientY - pointer1.clientY];
                        length = Math.sqrt(
                            Math.pow(vector[0], 2) + Math.pow(vector[1], 2)
                        );
                        origin_length = Math.sqrt(
                            Math.pow(origin_vector[0], 2) + Math.pow(origin_vector[1], 2)
                        );
                        cos = (vector[0]*origin_vector[0] + vector[1]*origin_vector[1])/(length*origin_length);

                        $(".panel").html(
                            "Pointer1: " + pointer1.clientX + ", " + pointer1.clientY + "<br>" +
                            "Pointer2: " + pointer2.clientX + ", " + pointer2.clientY + "<br>" +
                            "Rotation: " + Math.acos(cos));
                    });

                    $("#btn_upload").unbind().click(function(event){
                        upload("slide_create");
                    });
                    $("#btn_complete").unbind().click(function(event){
                        upload("quiz_complete");
                    });
                }

                reader.readAsDataURL(input.files[0]);
            }
        }

        $("#input-image").click(function(){
            this.value = null;
        });

        $("#input-image").change(function(){
            readURL(this);
        });

        function upload(action) {
            canvas = document.getElementById('myCanvas');
            slide_answer = $("#slide_answer").val();
            user_id = $("#user_id").val();
            quiz_id = $("#quiz_id").val();
            blob = Util.dataURLToBlob(canvas.toDataURL());
            var form_data = new FormData();
            form_data.append('slide_answer', slide_answer);
            form_data.append('original', blob);
            form_data.append('user_id', user_id);
            form_data.append('quiz_id', quiz_id);
            form_data.append('action', action);
            $.ajax({
                type: 'POST',
                url: '/',
                data: form_data,
                enctype: 'multipart/form-data',
                processData: false,
                contentType: false
            }).success(function(data) {
                action = data["Action"].toLowerCase();
                if (action == "quiz_complete") {
                    window.location.replace("/game/" + data["QuizId"]);
                } else {
                    $(".panel").html("Upload succeed.");
                    $("#user_id").val(data["UserId"]);
                    $("#quiz_id").val(data["QuizId"]);
                    reset_canvas();
                }
            }).error(function(data) {
                $(".panel").html("Upload failed.");
            });
            $(".panel").html("Upload...");
        }

        function transform(margin_left, margin_top, width, height) {
            $('#photo').css(
                {"margin-left": margin_left + "px",
                 "margin-top": margin_top + "px",
                 "width": width + "px",
                 "height": height + "px"}
            );

            canvas = document.getElementById('myCanvas');
            context = canvas.getContext('2d');
            context.clearRect(0, 0, canvas.width, canvas.height);
            context.drawImage(
                imageObj,
                0, 0, imageObj.width, imageObj.height,
                margin_left, margin_top, width, height
            );
        }

        function clear_canvas() {
            $('#photo').attr('src', '');
            canvas = document.getElementById('myCanvas');
            context = canvas.getContext('2d');
            context.clearRect(0, 0, canvas.width, canvas.height);
            transform(0, 0, 0, 0);
        }

        function reset_canvas() {
            $('#photo').attr('src', '');
            $('#photo').css(
                {"margin-left": "",
                 "margin-top": "",
                 "width": "auto",
                 "height":  "auto"}
            );
            canvas = document.getElementById('myCanvas');
            context.clearRect(0, 0, canvas.width, canvas.height);
        }

        $(document).ready(function(e){
            $("#box").css("height", $("#box").width()/2 + "px");
            canvas = document.getElementById('myCanvas');
            canvas.width = $("#box").width();
            canvas.height = $("#box").height();
        });

        </script>
    </body>
</html>
