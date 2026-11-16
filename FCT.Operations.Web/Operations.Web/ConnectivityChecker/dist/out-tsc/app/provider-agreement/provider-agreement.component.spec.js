import { TestBed } from '@angular/core/testing';
import { ProviderAgreementComponent } from './provider-agreement.component';
describe('ProviderAgreementComponent', () => {
    let component;
    let fixture;
    beforeEach(() => {
        TestBed.configureTestingModule({
            declarations: [ProviderAgreementComponent]
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
//# sourceMappingURL=provider-agreement.component.spec.js.map