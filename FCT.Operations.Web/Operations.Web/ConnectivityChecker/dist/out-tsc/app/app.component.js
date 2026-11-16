import { __decorate, __metadata } from "tslib";
import { Component } from '@angular/core';
import { ConnectivityCheckService } from './services/connectivity-check-service';
import { Router } from '@angular/router';
let AppComponent = class AppComponent {
    constructor(router) {
        this.router = router;
        // this.router.navigateByUrl('/login');
    }
    ngOnInit() {
        console.log("AppComponent init");
    }
};
AppComponent = __decorate([
    Component({
        selector: 'app-root',
        templateUrl: './app.component.html',
        styleUrls: ['./app.component.css'],
        providers: [ConnectivityCheckService]
    }),
    __metadata("design:paramtypes", [Router])
], AppComponent);
export { AppComponent };
//# sourceMappingURL=app.component.js.map