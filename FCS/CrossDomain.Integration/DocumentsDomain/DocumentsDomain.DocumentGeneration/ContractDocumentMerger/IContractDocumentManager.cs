using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SFA.FCT.DocumentsDomain.Common.Commands;
using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

namespace SFA.FCT.DocumentsDomain.DocumentGeneration.ContractDocumentMerger
{
    public interface IContractDocumentManager
    {
        void MergeContractDocuments(contract contractDocument);
    }
}
