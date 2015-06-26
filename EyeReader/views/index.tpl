<html>
    <title>test</title>
    <meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="/static/css/index.css" type="text/css" media="screen" />
    <head></head>
    <body>
        <form id="form1">
            <input type='file' id="imgInp" name="original"/>
            <div id="box" style="width:500px;height:250px;overflow: hidden;background-color: blue;">
                <img id="photo" src="#"/>
            </div>
            
            <input type="button" id="btn_upload" value="Upload"/>

            <div>
                <canvas id="myCanvas" width="500" height="250" style="display: None">
                </canvas>
            </div>
            <div class="panel"></div>
        </form>

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
                        $photo.css({"margin-left": (margin_left + event.deltaX) + "px",
                                    "margin-top": (margin_top + event.deltaY) + "px"});
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
                        $photo.css({"width": new_width + "px"});
                        transform(margin_left, margin_top, new_width, new_height);
                    });

                    $("#btn_upload").unbind().click(function(event){
                        upload();
                    });
                }

                reader.readAsDataURL(input.files[0]);
            }
        }

        $("#imgInp").change(function(){
            readURL(this);
        });

        function upload() {
            canvas = document.getElementById('myCanvas');
            blob = Util.dataURLToBlob(canvas.toDataURL());
            var fd = new FormData();
            fd.append('fname', 'eyes.jpg');
            fd.append('original', blob);
            $.ajax({
                type: 'POST',
                url: '/',
                data: fd,
                enctype: 'multipart/form-data',
                processData: false,
                contentType: false
            }).success(function(data) {
                $(".panel").html("Upload succeed.");
            }).error(function(data) {
                $(".panel").html("Upload failed.");
            });
            $(".panel").html("Upload...");
        }

        function transform(margin_left, margin_top, width, height) {
            canvas = document.getElementById('myCanvas');
            context = canvas.getContext('2d');
            context.clearRect(0, 0, 500, 250);
            context.drawImage(
                imageObj,
                0, 0, imageObj.width, imageObj.height,
                margin_left, margin_top, width, height
            );
        }

        </script>
    </body>
</html>
