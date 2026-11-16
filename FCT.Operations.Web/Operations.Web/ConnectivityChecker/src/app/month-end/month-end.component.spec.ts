import {  ComponentFixture } from '@angular/core/testing';
import { TestBed } from '@angular/core/testing';
import { MonthEndComponent } from './month-end.component';

describe('MonthEndComponent', () => {
  let component: MonthEndComponent;
  let fixture: ComponentFixture<MonthEndComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [ MonthEndComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(MonthEndComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
