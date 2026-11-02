import { ErrorHandler, Injectable, Injector } from '@angular/core';
import { ErrorHandlingService } from '../error-handlers/error-handling-service.service';

@Injectable()
export class GlobalErrorHandler implements ErrorHandler {

  constructor(private injector: Injector) {}

  handleError(error: any): void {
    const errorHandlingService = this.injector.get(ErrorHandlingService);
    errorHandlingService.handleClientError(error);
    // Additional global error handling logic
  }
}