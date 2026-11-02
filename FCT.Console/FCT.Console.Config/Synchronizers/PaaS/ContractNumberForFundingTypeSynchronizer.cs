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

    public class ContractNumberForFundingTypeSynchronizer : FundingTypeReader, ISynchronizeConfig
    {
        private readonly Func<IReadOnlyCollection<string>> _getExistingSequences;
        private readonly Action<string, int> _createSequenceWithCurrentValue;
        private readonly ICrmContractNumberRepository _crmContractNumberRepository;

        public ContractNumberForFundingTypeSynchronizer(
            Func<IReadOnlyCollection<string>> existingSequences,
            Action<string, int> sequenceWithCurrentValue,
            ICrmContractNumberRepository crmContractNumberRepository)
        {
            _getExistingSequences = existingSequences;
            _createSequenceWithCurrentValue = sequenceWithCurrentValue;
            _crmContractNumberRepository = crmContractNumberRepository;
        }

        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IReadOnlyCollection<FundingTypeSheetType> rows = ReadConfig(worksheetReader);

            IReadOnlyCollection<string> existingSequences = _getExistingSequences();

            List<SequenceNameInfo> fundingTypeExpectedSequences = rows.Select(r => MissingSequenceCreator.CreateSequenceNameInfo(ContractNumberType.Contract, r.FundingTypeCode))
                .ToList();

            MissingSequenceCreator.CreateMissingSequences(fundingTypeExpectedSequences, _createSequenceWithCurrentValue, existingSequences, ContractNumberType.Contract, _crmContractNumberRepository);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            // do nothing
        }
    }
}
