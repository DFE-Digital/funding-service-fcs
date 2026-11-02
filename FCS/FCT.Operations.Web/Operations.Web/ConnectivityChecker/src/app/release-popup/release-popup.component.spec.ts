import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ReleasePopupComponent } from './release-popup.component';

describe('ReleasePopupComponent', () => {
  let component: ReleasePopupComponent;
  let fixture: ComponentFixture<ReleasePopupComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ReleasePopupComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ReleasePopupComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
