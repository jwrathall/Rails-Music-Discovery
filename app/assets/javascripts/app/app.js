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
                    console.log('error:' + data)
                });
        }
    }
);
musicApp.controller('catalogController',
    function($scope, $http, $resource){
        var artists = $resource('/user/all_artists');
        $scope.artists = artists.query();


        //TODO move all this into a factory and implement ngResource
        $scope.removeArtist = function(data){
            console.log(data);
            $http({method: 'DELETE', url: '/user/destroy_artist', data:angular.toJson(data.id), headers: {'Content-Type':'application/json'}}).
                success(function(data, status, headers, config) {
                    console.log(data)
                       var index =$scope.artists.indexOf(data);
                        $scope.artists.splice(1-index,1);
                    //console.log($scope.artists);
                }).
                error(function(data, status, headers, config) {
                    console.log('error:' + data)
                });
        }
    }
);

musicApp.directive('genreFormat',
    function(){
        return {
            replace: true,
            scope: { genreFormat: '@' },
            link: function(scope, el, attrs) {
                if(!scope.$parent.$last){
                    scope.$watch('genreFormat', function(value) {
                       el.html(value + ', ')
                    });
                }else{
                    scope.$watch('genreFormat', function(value) {
                        el.html(value)
                    });
                }

            }
        };
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
//http://odetocode.com/blogs/scott/archive/2013/09/11/moving-data-in-an-angularjs-directive.aspx
musicApp.directive('removeArtist',
    function(){
        return{
            restrict: 'E',
            replace: true,
            transclude: true,
            scope: {
                event: '=event',
                model: '='
            },
            template: '<div class="icomatic" style="font-size:30px;padding-bottom:10px;"><span>minus</span></div>',
            link: function(scope, el, attr){
                el.on('click',
                    function(e){
                        e.preventDefault();
                        scope.event(scope.model);
                    }
                );
            }
        }
    }
);

