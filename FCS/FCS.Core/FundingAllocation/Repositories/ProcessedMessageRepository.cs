namespace FundingAllocation.Repositories
{
    using System;
    using System.Data.SqlClient;
    using System.Threading.Tasks;
    using DataStore;
    using DataStore.Model;
    using Microsoft.EntityFrameworkCore;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ProcessedMessageRepository : IProcessedMessageRepository
    {
        private readonly ILogger _logger;
        private readonly FundingAllocationContext _context;

        public ProcessedMessageRepository(ILogger logger, FundingAllocationContext context)
        {
            _logger = logger;
            _context = context;
        }

        public async Task Deduplicate(string messageId, string endpoint, string messageType, string businessKey)
        {
            bool canProcessMessage = await Add(messageId, endpoint, messageType, businessKey);

            if (!canProcessMessage)
            {
                string error = $"Duplicate message {messageType} received on endpoint {endpoint} for: {businessKey}";
                _logger.LogError(LoggingId.DuplicateMessage, error);
                throw new InvalidOperationException(error);
            }
        }

        private async Task<bool> Add(string messageId, string endpoint, string messageType, string businessKey)
        {
            const int violationOfPrimaryKeyConstraint = 2627;
            const int cannotInsertDuplicateKeyRowInObjectWithUniqueIndex = 2601;

            try
            {
                await _context.ProcessedMessages.AddAsync(new ProcessedMessage(messageId, endpoint, messageType,
                    businessKey));
                await _context.SaveChangesAsync();

                return true;
            }
            catch (DbUpdateException ex)
                when (ex.InnerException is SqlException {Number: violationOfPrimaryKeyConstraint} ||
                      ex.InnerException is SqlException {Number: cannotInsertDuplicateKeyRowInObjectWithUniqueIndex })
            {
                return false;
            }
            catch (Exception e)
            {
                var baseException = e.GetBaseException();
                _logger.LogError(1, $"Error in ProcessedMessageRepository::Add - base: {baseException.Message}, stack: {baseException.StackTrace}");
                
                throw;
            }
        }
    }
}
