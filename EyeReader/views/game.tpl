<html>
    <title>Eyes Reader</title>
    <meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="/static/css/index.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="/static/css/angular-csp.css" type="text/css" media="screen" />
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.14/angular.min.js"></script>
    <script src="/static/js/angular/app.js"></script>
    <script src="/static/js/angular/controllers/game.js"></script>

    <style type="text/css">
    .eyes_image{
        width:500px;
        max-width: 100%;
    }
    .option-box{
        float: left;
        border: 1px black solid;
        margin: 5px;
        padding: 10px;
    }
    .last, .next{
        border: 1px black solid;
        padding: 10px;
        text-align: center;
        float: left;
    }
    .slide_panel{
        width: 200px;
        margin-left: auto;
        margin-right: auto;
    }
    </style>

    <head></head>
    <body ng-app="eyes_reader" ng-controller="GameCtrl" ng-init="game_init({{.slide_num}})">
        <h1>
            {[{ cur_slide + 1 }]} / {{.slide_num}} Slides
        </h1>
        <div>
            {{range $slide_index, $slide := .slides}}
            <div class="ng-hide" ng-show="cur_slide=={{$slide_index}}" ng-cloak>
                <div>
                    <img class="eyes_image" src="/{{$slide.EyesImage}}"/>
                </div>
                <div class="choices_panel">
                    {{range $option := $slide.Answer | string_to_array}}
                    <div class="option-box">
                        {{$option}}
                    </div>
                    {{end}}
                    <div class="new-line"></div>
                </div>
                <div class="slide_panel">
                    <div class="last clickable" ng-click="last_slide()">
                        上一个
                    </div>
                    <div class="next clickable" ng-click="next_slide()">
                        下一个
                    </div>
                    <div class="new-line"></div>
                </div>
            </div>
            {{end}}
        </div>
    </body>
</html>
