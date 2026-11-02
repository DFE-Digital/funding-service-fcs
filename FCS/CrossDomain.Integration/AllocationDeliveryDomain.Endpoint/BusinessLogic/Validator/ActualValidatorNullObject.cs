namespace SFA.FCT.AllocationDeliveryDomain.Endpoint.BusinessLogic.Validator
{
    using System.Collections.Generic;
    using Common.Storage;
    using CrossDomain.Integration.Entities.Data;

    /// <summary>
    /// Null implementation of IActualValidator - to be removed once actual implementation has been completed
    /// </summary>
    /// <remarks>
    /// This validation returns true for any actual
    /// </remarks>
    public class ActualValidatorNullObject : IActualValidator
    {
        public IList<string> Validate(EnrichedReportedActual actual, bool processFutureActuals, ConnectionInfo connectionInfo)
        {
            return new List<string>();
        }

        public List<EnrichedReportedActual> GetValidActuals(List<EnrichedReportedActual> listToValidate, ConnectionInfo connectionInfo)
        {
            return new List<EnrichedReportedActual>();
        }

        public bool IsCalcDateAfterFspActivityCloseDate(string fspCode, ConnectionInfo connectionInfo)
        {
            return false;
        }
    }
}