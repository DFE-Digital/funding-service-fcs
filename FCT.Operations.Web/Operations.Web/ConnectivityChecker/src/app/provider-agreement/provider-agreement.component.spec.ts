import {  ComponentFixture, TestBed } from '@angular/core/testing';

import { ProviderAgreementComponent } from './provider-agreement.component';

describe('ProviderAgreementComponent', () => {
  let component: ProviderAgreementComponent;
  let fixture: ComponentFixture<ProviderAgreementComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [ ProviderAgreementComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ProviderAgreementComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
