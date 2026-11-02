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

    public class ContractNumberForAgencySynchronizer : AgencyReader, ISynchronizeConfig
    {
        private readonly Func<IReadOnlyCollection<string>> _getExistingSequences;
        private readonly Action<string, int> _createSequenceWithCurrentValue;
        private readonly ICrmContractNumberRepository _crmContractNumberRepository;

        public ContractNumberForAgencySynchronizer(
            Func<IReadOnlyCollection<string>> getExistingSequences,
            Action<string, int> createSequenceWithCurrentValue,
            ICrmContractNumberRepository crmContractNumberRepository)
        {
            _getExistingSequences = getExistingSequences;
            _createSequenceWithCurrentValue = createSequenceWithCurrentValue;
            _crmContractNumberRepository = crmContractNumberRepository;
        }

        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IReadOnlyCollection<AgencySheetType> rows = ReadConfig(worksheetReader);

            IReadOnlyCollection<string> existingSequences = _getExistingSequences();

            List<SequenceNameInfo> agentExpectedSequences = rows.Select(r => MissingSequenceCreator.CreateSequenceNameInfo(ContractNumberType.Master, r.AgencyShortCode))
                .ToList();

            MissingSequenceCreator.CreateMissingSequences(agentExpectedSequences, _createSequenceWithCurrentValue, existingSequences, ContractNumberType.Master, _crmContractNumberRepository);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            throw new System.NotImplementedException();
        }
    }
}
