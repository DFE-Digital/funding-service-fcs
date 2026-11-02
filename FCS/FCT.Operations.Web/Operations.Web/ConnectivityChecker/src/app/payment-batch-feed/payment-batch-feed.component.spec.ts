import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PaymentBatchFeedComponent } from './payment-batch-feed.component';

describe('PaymentBatchFeedComponent', () => {
  let component: PaymentBatchFeedComponent;
  let fixture: ComponentFixture<PaymentBatchFeedComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ PaymentBatchFeedComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(PaymentBatchFeedComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
