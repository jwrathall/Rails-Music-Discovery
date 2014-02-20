var musicApp = angular.module('musicApp', [
    'ngCookies',
    'ngResource',
    'ngSanitize',
    'ui.bootstrap'
]);
musicApp.config([
    "$httpProvider", function($httpProvider) {
        $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
    }
]);

musicApp.controller('searchResultsController',
    function($scope, $http, $modal, $timeout){
        $scope.saveArtist = function(data){
            $http({method: 'POST', url: '/user/save_artist', data: angular.toJson(data), headers: {'Content-Type':'application/json'}}).
                success(function(data, status, headers, config) {
                    console.log(data);
                        var modalContent = {
                                artist: 'Deftones',
                                message: 'has been saved to your catalog'
                            }
                       var modalInstance = $modal.open({
                            templateUrl: '/app/partials/modal.html',
                            controller: 'modalController',
                            resolve: {
                                returnData: function () {
                                    return modalContent;
                                }
                            }
                        });
                    $timeout(modalInstance.close, 1500);
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
            var index =$scope.artists.indexOf(data);

            //console.log($scope.artists);
            $http({method: 'DELETE', url: '/user/destroy_artist', data:angular.toJson(data.id), headers: {'Content-Type':'application/json'}}).
                success(function(data, status, headers, config) {
                    $scope.artists.splice(index,1);
                }).
                error(function(data, status, headers, config) {
                    console.log('error:' + data)
                });
        }
    }
);

musicApp.controller('modalController',
    function($scope, $modalInstance, returnData){
        $scope.data = returnData;
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

musicApp.service('modalService',
    function($modal){
        var modalDefaults = {
            backdrop: true,
            keyboard: true,
            modalFade: true,
            templateUrl: '/app/partials/modal.html'
        }
        var modalOptions = {
            message: 'perform this action'
        };

        this.showModal = function(customOptions){
           return this.show({}, customOptions);
        }
        this.show = function(customOptions){

            modalDefaults.controller = function ($scope, $modalInstance) {
                $scope.modalOptions = customOptions;
            }
            return $modal.open(modalDefaults).result;
        }
    }
);

