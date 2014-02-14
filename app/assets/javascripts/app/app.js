var musicApp = angular.module('musicApp', [
    'ngCookies',
    'ngResource',
    'ngSanitize'
]);
musicApp.config([
    "$httpProvider", function($httpProvider) {
        $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
    }
]);

musicApp.controller('searchResultsController',
    function($scope, $http){
        $scope.saveArtist = function(data){
            //great, got the data now send it to a rails controller to have some fun
            //angular.toJson(data)
            console.log(angular.toJson(data));
            $http({method: 'POST', url: '/user/save_artist', data: angular.toJson(data), headers: {'Content-Type':'application/json'}}).
                success(function(data, status, headers, config) {
                    // this callback will be called asynchronously
                    // when the response is available
                    console.log(data, status, headers, config)
                }).
                error(function(data, status, headers, config) {
                    // called asynchronously if an error occurs
                    // or server returns response with an error status.
                    console.log(data, status, headers, config)
                });
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

