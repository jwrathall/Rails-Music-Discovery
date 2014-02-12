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
            console.log(data);
            $http({method: 'POST', url: '/user/save_artist', data: data}).
                success(function(data, status, headers, config) {
                    // this callback will be called asynchronously
                    // when the response is available
                    console.log(data)
                }).
                error(function(data, status, headers, config) {
                    // called asynchronously if an error occurs
                    // or server returns response with an error status.
                    console.log(data)
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


/*

$http({
    method: "POST",
    // url: "http://staging.evas.bm/wp-content/themes/evas/form-process.php",
    //url: "http://173.192.219.24/~evasnai/staging/wp-content/themes/evas/form-process.php",
    url: "http://evasnailcare.com/wp-content/themes/evas/form-process.php",
    data: $.param($scope.data),
    headers : {'Content-Type':'application/x-www-form-urlencoded'}
})
    .success(function(data){
        if(!data.success){
            $scope.response = {
                success:false,
                css:"error",
                message:data.message
            };
        }else{
            $scope.response = {
                success:true,
                css:"success",
                message:data.message
            };

        }
    }
);*/
