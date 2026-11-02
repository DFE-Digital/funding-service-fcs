namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.TsAndCs
{
    using System;
    using System.Collections.Generic;
    using Common.Models;

    public interface IEdskSchedule1DocumentPartCreator
    {
        IDictionary<string, DocumentGenerationRequest> GetDocumentGenerationRequests(
            string contractType,
            string fundingPeriod,
            string fundingTypeCode,
            DateTime contractStartDate,
            string fspGroupCode,
            string templateContainer);
    }
}