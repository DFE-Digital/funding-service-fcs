import { Component, OnInit } from '@angular/core';
import {ConnectivityCheckService} from './services/connectivity-check-service';
import {Router} from '@angular/router';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
  providers: [ConnectivityCheckService]
})
export class AppComponent implements OnInit{
  constructor(private router: Router) {
     // this.router.navigateByUrl('/login');
    }

  ngOnInit() {
      console.log("AppComponent init");
    
  }
}
