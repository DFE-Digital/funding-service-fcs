import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ApprenticeshipLevyComponent } from './apprenticeship-levy.component';

describe('ApprenticeshipLevyComponent', () => {
  let component: ApprenticeshipLevyComponent;
  let fixture: ComponentFixture<ApprenticeshipLevyComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ApprenticeshipLevyComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ApprenticeshipLevyComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
