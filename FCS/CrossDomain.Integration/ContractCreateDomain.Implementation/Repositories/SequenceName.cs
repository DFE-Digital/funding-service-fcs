namespace SFA.FCT.ContractCreateDomain.Implementation.Repositories
{
    public class SequenceName
    {
        private readonly SequenceType _sequenceType;
        private readonly string _context;

        public SequenceName(SequenceType sequenceType, string context)
        {
            _sequenceType = sequenceType;
            _context = context;
        }

        public override string ToString()
        {
            return $@"{_sequenceType}_{_context
                .Replace("+", "_plus_")
                .Replace("-", "_hyphen_")
                .Replace(" ", string.Empty)}_seq";
        }
    }
}
