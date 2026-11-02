import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CleanContractDataComponent } from './clean-contract-data.component';
import {} from 'jasmine';

describe('CleanContractDataComponent', () => {
  let component: CleanContractDataComponent;
  let fixture: ComponentFixture<CleanContractDataComponent>;

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
