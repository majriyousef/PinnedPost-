param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Path
)

$ErrorActionPreference = 'Stop'
$resolved = Resolve-Path -LiteralPath $Path
$rows = Import-Csv -LiteralPath $resolved
if (-not $rows) { throw 'No rows found' }

$required = @('conversation_id', 'timestamp', 'sender', 'message')
$headers = $rows[0].PSObject.Properties.Name
$missing = $required | Where-Object { $_ -notin $headers }
if ($missing) { throw "Missing columns: $($missing -join ', ')" }

$patterns = [ordered]@{
    price = '(?i)\b(too much|expensive|cant afford|can''t afford|budget)\b'
    no_reply = '(?i)\b(no reply|no answer|ghosted)\b'
    work_time = '(?i)\b(work|busy|later|tomorrow)\b'
    stop = '(?i)\b(stop|not interested|dont want|don''t want|no thanks)\b'
}

$signals = [ordered]@{}
foreach ($label in $patterns.Keys) { $signals[$label] = 0 }
foreach ($row in $rows) {
    $message = [string]$row.message
    foreach ($label in $patterns.Keys) {
        if ($message -match $patterns[$label]) {
            $signals[$label]++
        }
    }
}

$result = [ordered]@{
    rows = $rows.Count
    conversations = @($rows.conversation_id | Sort-Object -Unique).Count
    senders = @($rows.sender | Group-Object | ForEach-Object { [ordered]@{ name = $_.Name; count = $_.Count } })
    possible_drop_signals = $signals
    warning = 'Keyword signals require manual backread; they are not final classifications.'
}

$result | ConvertTo-Json -Depth 5
