import { TestBed } from '@angular/core/testing';
import { StorageService } from './storage.service';
describe('StorageService', () => {
    let service;
    beforeEach(() => {
        TestBed.configureTestingModule({});
        service = TestBed.inject(StorageService);
    });
    it('should be created', () => {
        expect(service).toBeTruthy();
    });
});
//# sourceMappingURL=storage.service.spec.js.map