$filePath = "C:\FCS-Migration\FCS\CrossDomain.Integration\ContractRequestDomain.BusinessLogic\Services\FileValidationFscEnrichment.cs"

# Read the file
$content = [System.IO.File]::ReadAllText($filePath)

# Fix 1: Add URL validation before DownloadString
$content = $content -replace `
    'var url = ConfigurationManager\.AppSettings\["FscEnrichmentUrl"\];\s+var webResponse = client\.DownloadString\(url \+ requestArguments\);', `
    'var url = ConfigurationManager.AppSettings["FscEnrichmentUrl"];
                    if (string.IsNullOrWhiteSpace(url))
                    {
                        _logger.LogError(ContractRequestDomainEventLoggingId.ErrorFetchingFscData, "FscEnrichmentUrl configuration is missing or empty for batch {0}", batchId);
                        throw new InvalidOperationException("FscEnrichmentUrl configuration setting is not configured");
                    }
                    var webResponse = client.DownloadString(url + requestArguments);'

# Fix 2: Add WebException handling
$content = $content -replace `
    'catch \(Exception ex\)\s+\{\s+_logger\.LogError\(ContractRequestDomainEventLoggingId\.ErrorFetchingFscData, "Exception when fetching FSC data for batch \{0\}: \{1\}", batchId, ex\.ToString\(\)\);\s+throw;\s+\}', `
    'catch (WebException webEx)
                {
                    _logger.LogError(ContractRequestDomainEventLoggingId.ErrorFetchingFscData, "WebException when fetching FSC data for batch {0}: {1}", batchId, webEx.ToString());

                    if (webEx.Response is HttpWebResponse response)
                    {
                        _logger.LogError(ContractRequestDomainEventLoggingId.ErrorFetchingFscData, "HTTP Status Code: {0} ({1})", (int)response.StatusCode, response.StatusDescription);
                    }

                    throw;
                }
                catch (Exception ex)
                {
                    _logger.LogError(ContractRequestDomainEventLoggingId.ErrorFetchingFscData, "Exception when fetching FSC data for batch {0}: {1}", batchId, ex.ToString());
                    throw;
                }'

# Write back to file
[System.IO.File]::WriteAllText($filePath, $content)
Write-Host "Fixed FileValidationFscEnrichment.cs"
