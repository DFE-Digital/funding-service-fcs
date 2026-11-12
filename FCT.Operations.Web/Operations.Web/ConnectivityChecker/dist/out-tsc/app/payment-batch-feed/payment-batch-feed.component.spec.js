import { TestBed } from '@angular/core/testing';
import { PaymentBatchFeedComponent } from './payment-batch-feed.component';
describe('PaymentBatchFeedComponent', () => {
    let component;
    let fixture;
    beforeEach(async () => {
        await TestBed.configureTestingModule({
            declarations: [PaymentBatchFeedComponent]
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
//# sourceMappingURL=payment-batch-feed.component.spec.js.map