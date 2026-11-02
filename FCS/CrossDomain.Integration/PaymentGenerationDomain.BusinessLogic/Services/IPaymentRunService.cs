namespace PaymentGenerationDomain.BusinessLogic.Services
{
    using System;
    using System.Threading.Tasks;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using CorporateSchema = SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentGeneration;

    public interface IPaymentRunService
    {
        Task PublishPaymentPeriod(
            PaymentTimetable paymentTimetable,
            Func<CorporateSchema.PaymentPeriod, int, Task> paymentPeriodPublished,
            Func<string, Task> paymentPeriodValidationFailed,
            ConnectionInfo connectionInfo);
    }
}
