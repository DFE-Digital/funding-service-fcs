import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ReRunFailedLevyContractComponent } from './re-run-failed-levy-contract.component';

describe('ReRunFailedLevyContractComponent', () => {
  let component: ReRunFailedLevyContractComponent;
  let fixture: ComponentFixture<ReRunFailedLevyContractComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ReRunFailedLevyContractComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ReRunFailedLevyContractComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

