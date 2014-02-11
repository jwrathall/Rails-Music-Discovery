var musicApp = angular.module('musicApp', [
    'ngCookies',
    'ngResource',
    'ngSanitize'
]);

musicApp.controller('searchResultsController',
    function($scope){
        $scope.saveArtist = function(data){
            //great, got the data now send it to a rails controller to have some fun
        }
    }
);

musicApp.directive('saveArtist',
    function(){
        return{
            restrict: 'E',
            replace: true,
            transclude: true,
            scope: {
                event: '&event'
            },
            template: '<div class="icomatic" style="font-size:30px;padding-bottom:10px;"><span>plus</span></div>',
            link: function(scope, el, attr){
                el.on('click',
                    function(e){
                        e.preventDefault();
                        scope.event(attr.event);
                    }
                );
            }
        }
    }
);
