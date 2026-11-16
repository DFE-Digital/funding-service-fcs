import { TestBed } from '@angular/core/testing';
import { CleanContractDataComponent } from './clean-contract-data.component';
describe('CleanContractDataComponent', () => {
    let component;
    let fixture;
    beforeEach(async () => {
        await TestBed.configureTestingModule({
            imports: [CleanContractDataComponent]
        })
            .compileComponents();
        fixture = TestBed.createComponent(CleanContractDataComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });
    it('should create', () => {
        expect(component).toBeTruthy();
    });
});
//# sourceMappingURL=clean-contract-data.component.spec.js.map