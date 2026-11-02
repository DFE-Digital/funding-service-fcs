using System.Collections.Generic;
using SFA.FCT.FundingStreamConfigDomain.Common;

namespace SFA.FCT.FundingStreamConfigDomain.Integration
{
    public interface IDocumentPartConfigurationManager
    {
        IList<DocumentSectionType> GetDocumentPartConfigurationItems();
    }
}
