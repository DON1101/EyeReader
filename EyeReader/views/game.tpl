<html>
    <title>Eyes Reader</title>
    <meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="/static/css/index.css" type="text/css" media="screen" />

    <style type="text/css">
    .eyes_image{
        width:500px;
        max-width: 100%;
    }
    </style>

    <head></head>
    <body>
        <h1>
            {{.slide_num}} Slides
        </h1>
        <div>
            {{range $slide := .slides}}
            <div>
                <img class="eyes_image" src="/{{$slide.EyesImage}}"/>
            </div>
            {{end}}
        </div>
    </body>
</html>
