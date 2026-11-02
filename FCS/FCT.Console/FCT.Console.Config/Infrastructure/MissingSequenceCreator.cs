namespace FCT.Console.Config.Infrastructure
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Repositories;

    public static class MissingSequenceCreator
    {
        private const int SequenceStartValue = 1000;

        public static void CreateMissingSequences(
            IReadOnlyCollection<SequenceNameInfo> expectedSequences,
            Action<string, int> createSequenceWithCurrentValue,
            IReadOnlyCollection<string> existingSequences,
            ContractNumberType contractNumberType,
            ICrmContractNumberRepository crmContractNumberRepository
        )
        {
            List<SequenceNameInfo> missingSequences =
                expectedSequences.Where(existingSequence => !existingSequences
                    .Select(s => s.ToUpper())
                    .Contains(existingSequence.SequenceName.ToUpper()))
                    .ToList();

            missingSequences.ForEach(missingSequence =>
            {
                // todo: replace the line below with the constant after this code has gone live
                int? currentNumberFromCrm = crmContractNumberRepository.GetCurrentContractNumber(contractNumberType, missingSequence.Context);
                int sequenceStartValue = SequenceStartValue;
                if (currentNumberFromCrm.HasValue)
                {
                    sequenceStartValue = currentNumberFromCrm.Value + 1;
                }

                createSequenceWithCurrentValue(missingSequence.SequenceName, sequenceStartValue);
            });
        }

        public static SequenceNameInfo CreateSequenceNameInfo(ContractNumberType contractNumberType, string contextString)
        {
            return new SequenceNameInfo($@"{contractNumberType}_{contextString
                .Replace("+", "_plus_")
                .Replace("-", "_hyphen_")
                .Replace(" ", string.Empty)}_seq", contextString);
        }
    }
}
