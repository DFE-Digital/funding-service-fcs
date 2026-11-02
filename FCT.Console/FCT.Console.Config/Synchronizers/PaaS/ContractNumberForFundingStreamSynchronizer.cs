namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Config.Repositories;
    using Excel;
    using ExcelTypes;
    using Infrastructure;
    using Readers;

    public class ContractNumberForFundingStreamSynchronizer : FundingStreamSheetReader, ISynchronizeConfig
    {
        private readonly Func<IReadOnlyCollection<string>> _getExistingSequences;
        private readonly Action<string, int> _createSequenceWithCurrentValue;
        private readonly ICrmContractNumberRepository _crmContractNumberRepository;
        private readonly string _agencyCode;

        public ContractNumberForFundingStreamSynchronizer(
            Func<IReadOnlyCollection<string>> existingSequences,
            Action<string, int> sequenceWithCurrentValue,
            ICrmContractNumberRepository crmContractNumberRepository, string agencyCode)
        {
            _getExistingSequences = existingSequences;
            _createSequenceWithCurrentValue = sequenceWithCurrentValue;
            _crmContractNumberRepository = crmContractNumberRepository;
            _agencyCode = agencyCode;
        }

        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IReadOnlyCollection<FundingStreamSheetType> rows = ReadConfig(worksheetReader, _agencyCode);

            IReadOnlyCollection<string> existingSequences = _getExistingSequences();

            List<SequenceNameInfo> fundingStreamExpectedSequences = rows.Select(r => MissingSequenceCreator.CreateSequenceNameInfo(ContractNumberType.Allocation, r.Code))
                .ToList();

            MissingSequenceCreator.CreateMissingSequences(fundingStreamExpectedSequences, _createSequenceWithCurrentValue, existingSequences, ContractNumberType.Allocation, _crmContractNumberRepository);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            // do nothing
        }
    }
}
