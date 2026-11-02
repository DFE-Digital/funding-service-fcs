namespace SFA.FCT.AllocationDeliveryDomain.Endpoint.BusinessLogic.Validator
{
    using System.Collections.Generic;
    using Common.Storage;
    using CrossDomain.Integration.Entities.Data;

    public interface IActualValidator
    {
        List<EnrichedReportedActual> GetValidActuals(List<EnrichedReportedActual> listToValidate, ConnectionInfo connectionInfo);

        IList<string> Validate(EnrichedReportedActual actual, bool processFutureActuals, ConnectionInfo connectionInfo);

        bool IsCalcDateAfterFspActivityCloseDate(string fspCode, ConnectionInfo connectionInfo);
    }
}
