import { TestBed } from '@angular/core/testing';
import { LevyAmendmentComponent } from './levy-amendment.component';
describe('LevyAmendmentComponent', () => {
    let component;
    let fixture;
    beforeEach(() => {
        TestBed.configureTestingModule({
            declarations: [LevyAmendmentComponent]
        })
            .compileComponents();
    });
    beforeEach(() => {
        fixture = TestBed.createComponent(LevyAmendmentComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });
    it('should create', () => {
        expect(component).toBeTruthy();
    });
});
//# sourceMappingURL=levy-amendment.component.spec.js.map