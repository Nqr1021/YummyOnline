﻿var app = angular.module('orderApp', ['ngRoute', 'ngStorage', 'ui.bootstrap']);

app.config(function ($httpProvider) {
	$httpProvider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';
});