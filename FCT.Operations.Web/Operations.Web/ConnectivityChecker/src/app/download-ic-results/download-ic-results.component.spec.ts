import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DownloadIcResultsComponent } from './download-ic-results.component';

describe('DownloadIcResultsComponent', () => {
  let component: DownloadIcResultsComponent;
  let fixture: ComponentFixture<DownloadIcResultsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ DownloadIcResultsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(DownloadIcResultsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
