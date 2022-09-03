function Write-LogMessage {
    [CmdletBinding(DefaultParameterSetName = 'Color')]
    param (
        # Output type
        [Parameter(
            Mandatory,
            ParameterSetName = 'OutputType',
            HelpMessage = 'Azure DevOps supported output types'
        )]
        [string]
        [ValidateSet(
            'warning',
            'error',
            'debug',
            'command',
            'section',
            'group',
            'endgroup'
        )]
        $OutputType,

        # Color
        [Parameter(
            Mandatory,
            ParameterSetName = 'Color'
        )]
        [string]
        [ValidateSet(
            'black',
            'red',
            'green',
            'yellow',
            'blue',
            'magenta',
            'cyan',
            'white',
            'gray',
            'bright red',
            'bright green',
            'bright yellow',
            'bright blue',
            'bright megenta',
            'bright cyan',
            'bright white'
        )]
        $Color,

        # If it should be Background highlighted
        [Parameter(
            ParameterSetName = 'Color'
        )]
        [switch]
        $BackgroundColor,

        # Message to print
        [Parameter(
            ParameterSetName = 'OutputType',
            HelpMessage = 'Message to print'
        )]
        [Parameter(
            Mandatory,
            ParameterSetName = 'Color',
            HelpMessage = 'Message to print'
        )]
        [string]
        $Message,

        [Parameter(ParameterSetName = 'OutputType')]
        [Parameter(ParameterSetName = 'Color')]
        [ValidateSet(
            'Verbose',
            'Output'
        )]
        [string]
        $OutputStream = 'Verbose'
    )
    switch ($PSCmdlet.ParameterSetName) {
        'Color' {
            switch ($Color) {
                'black' {$id = 30}
                'red' {$id = 31}
                'green' {$id = 32}
                'yellow' {$id = 33}
                'blue' {$id = 34}
                'magenta' {$id = 35}
                'cyan' {$id = 36}
                'white' {$id = 37}
                'gray' {$id = 90}
                'bright red' {$id = 91}
                'bright green' {$id = 92}
                'bright yellow' {$id = 93}
                'bright blue' {$id = 94}
                'bright megenta' {$id = 95}
                'bright cyan' {$id = 96}
                'bright white' {$id = 97}
            }
            if ($BackgroundColor.IsPresent) {
                # Add 10 to set it to background color.
                $id = $id+10
            }
            $StartString = "$([char]27)[$id`m"
            $FormattedString = '{0}{1}{2}' -f $StartString, $Message, "$([char]27)[0m"
        }
        'OutputType' {
            Switch ($OutputType) {
                'warning' {$StartString = "##[warning]"}
                'error' {$StartString =  "##[error]"}
                'debug' {$StartString =  "##[debug]"}
                'command' {$StartString =  "##[command]"}
                'section' {$StartString =  "##[section]"}
                'group' {$StartString =  "##[group]"}
                'endgroup' {$StartString =  "##[endgroup]"}
            }
            $FormattedString = '{0}{1}' -f $StartString, $Message
        }
    }
    Switch ($OutputStream) {
        'Verbose' {Write-verbose "$FormattedString" -Verbose}
        'Output' {Write-output "$FormattedString"}
    }
}