namespace SFA.FCT.Operations.Integrity.Repositories
{
    using System;
    using System.Collections.Generic;

    public interface IPaasFundingStreamPeriodRepository
    {
        IReadOnlyCollection<string> GetFundingStreamPeriodCodesThatAreActive(DateTime dateTime);
        bool IsFundingStreamPeriodPayOnInstruction(string fspCode);
    }
}
