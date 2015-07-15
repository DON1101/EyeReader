angular_module
    .controller("GameCtrl", function($scope, $http, $window) {
        $scope.cur_slide = 0;
        $scope.slide_num = 0;

        $scope.game_init = function(slide_num) {
            $scope.slide_num = parseInt(slide_num);
        };

        $scope.next_slide = function() {
            slide_move(1);
        };

        $scope.last_slide = function() {
            slide_move(-1);
        };

        function slide_move(direction) {
            if(direction > 0){
                if($scope.cur_slide < $scope.slide_num - 1){
                    $scope.cur_slide += 1;
                }
                else {
                    alert("Last slide");
                }
            }
            else {
                if($scope.cur_slide > 0){
                    $scope.cur_slide -= 1;
                }
                else {
                    alert("First slide");
                }
            }
        }
    })
;
