import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AccessabilityPageComponent } from './accessability-page.component';

describe('AccessabilityPageComponent', () => {
  let component: AccessabilityPageComponent;
  let fixture: ComponentFixture<AccessabilityPageComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AccessabilityPageComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AccessabilityPageComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
