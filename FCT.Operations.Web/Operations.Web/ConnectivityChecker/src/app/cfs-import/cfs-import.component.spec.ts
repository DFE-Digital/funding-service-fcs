import {  ComponentFixture, TestBed } from '@angular/core/testing';
import { CfsImportComponent } from './cfs-import.component';


describe('CfsImportComponent', () => {
  let component: CfsImportComponent;
  let fixture: ComponentFixture<CfsImportComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [ CfsImportComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CfsImportComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
