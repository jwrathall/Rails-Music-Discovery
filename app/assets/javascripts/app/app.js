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
    function($scope, $http, dialogFactory){
        $scope.saveArtist = function(data){
            console.log(angular.toJson(data));
            var artist = data;
            $http({method: 'POST', url: '/user/save_artist', data: {'mbid':data}, headers: {'Content-Type':'application/json'}}).
                success(function(data, status, headers, config) {
                    console.log(data );
                    /*if(data.success === true){
                        var modalContent = {
                            title: 'Artist Saved',
                            artist: artist.name,
                            message: 'has been saved to your catalog',
                            icon: 'check'
                        }
                    }else{
                        var modalContent = {
                            title: data.error,
                            artist:'',
                            message: data.message,
                            icon: 'cancel'
                        }
                    }

                    dialogFactory.notify(modalContent);*/
                }).
                error(function(data, status, headers, config) {
                    console.log(data, status);
                    var modalContent = {
                        title: 'Error Adding Artist', artist: '', message: 'There has been an error adding that artist.', icon: 'error'
                    }
                    dialogFactory.notify(modalContent);
                });
        }
    }
);
musicApp.controller('catalogController',
    function($scope, $http, $resource, dialogFactory){

        $http({method: 'GET', url: '/user/all_artists'}).
            success(function(data, status, headers, config) {
                console.log(data.catalog);
                if(data.success === true){
                    $scope.catalog = data.catalog;
                }
            }).
            error(function(data, status, headers, config) {
                console.log(data);
                // called asynchronously if an error occurs
                // or server returns response with an error status.
            });

        //TODO move all this into a factory and implement ngResource
        $scope.removeArtist = function(data){
            var artist = data;
            var index =$scope.catalog.artists.indexOf(data);
            $http({method: 'DELETE', url: '/user/destroy_artist', data:angular.toJson(data.id), headers: {'Content-Type':'application/json'}}).
                success(function(data, status, headers, config) {
                    $scope.catalog.artists.splice(index,1);
                    $scope.catalog.count -= 1;
                    var modalContent = {
                        title: 'Artist Removed', artist: artist.name, message: 'has been removed from your catalog.', icon: 'cancel'
                    }
                    dialogFactory.notify(modalContent);
                }).
                error(function(data, status, headers, config) {
                    var modalContent = {
                        title: 'Error Removing Artist', artist: '', message: 'There has been an error removing that artist.', icon: 'error'
                    }
                    dialogFactory.notify(modalContent);
                });
        }
    }
);

musicApp.controller('releasesController',
    function($scope, $http, $resource){
        $scope.saveArtist = function(data){

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
            template: '<div class="icomatic" style="font-size:30px;padding-bottom:10px;"><span>save</span></div>',
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
            template: '<div class="icomatic" style="font-size:30px;padding-bottom:10px;"><span>delete</span></div>',
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

musicApp.factory('dialogFactory',
    function($modal, $timeout){
        return{
            notify: function(modalContent){
                var modalInstance =  $modal.open({
                    templateUrl: '/app/partials/modal.html',
                    controller: 'modalController',
                    resolve: {
                        returnData: function () {
                            return modalContent;
                        }
                    }

                });
                $timeout(modalInstance.close, 2000);
                return modalInstance;
            }

        }

    }
);

