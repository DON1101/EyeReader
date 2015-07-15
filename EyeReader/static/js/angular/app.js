angular_module = angular.module("eyes_reader", [])
.config(function($interpolateProvider){
    $interpolateProvider.startSymbol('{[{').endSymbol('}]}');
})
;
