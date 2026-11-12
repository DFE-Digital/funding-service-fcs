import { TestBed } from '@angular/core/testing';
import { DigitisationReleaseMgmtComponent } from './digitisation-release-mgmt.component';
describe('DigitisationReleaseMgmtComponent', () => {
    let component;
    let fixture;
    beforeEach(async () => {
        await TestBed.configureTestingModule({
            imports: [DigitisationReleaseMgmtComponent]
        })
            .compileComponents();
        fixture = TestBed.createComponent(DigitisationReleaseMgmtComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });
    it('should create', () => {
        expect(component).toBeTruthy();
    });
});
//# sourceMappingURL=digitisation-release-mgmt.component.spec.js.map