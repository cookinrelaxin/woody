import Foundation

func isLinebreak(_ scalar: Scalar) -> Bool
{
    switch scalar.value
    {
        case 0x000A, 0x000D : return true
        default             : return false
    }
}

func isWhitespace(_ scalar: Scalar) -> Bool
{
    switch scalar.value
    {
        case 0x0000                      : return true
        case 0x0009                      : return true
        case 0x000B                      : return true
        case 0x000C                      : return true
        case 0x0020                      : return true
        case _ where isLinebreak(scalar) : return true
        default                          : return false
    }
}

func isIdentifierHead(_ scalar: Scalar) -> Bool
{
    switch scalar.value
    {
        case 0x0061...0x007A     : return true

        case underscore.value                     : return true

        case 0x00A8, 0x00AA, 0x00AF,
             0x00B2...0x00B5, 0x00B7...0x00BA     : return true

        case 0x00BC...0x00BE, 0x00C0...0x00D6,
             0x00D8...0x00F6, 0x00F8...0x00FF     : return true

        case 0x0100...0x02FF                      : return true

        case 0x0370...0x167F                      : return true

        case 0x1681...0x180D                      : return true

        case 0x180F...0x1DBF                      : return true

        case 0x200B...0x200D, 0x202A...0x202E,
             0x203F...0x2040, 0x2054,
             0x2060...0x206F                      : return true

        case 0x2070...0x20CF, 0x2100...0x218F,
             0x2460...0x24FF,  0x2776...0x2793    : return true

        case 0x2C00...0x2DFF, 0x2E80...0x2FFF     : return true

        case 0x3004...0x3007, 0x3021...0x302F,
             0x3031...0x303F, 0x3040...0xD7FF     : return true

        case 0xF900...0xFD3D, 0xFD40...0xFDCF,
             0xFDF0...0xFE1F,  0xFE30...0xFE44    : return true

        case 0xFE47...0xFFFD                      : return true

        case 0x10000...0x1FFFD, 0x20000...0x2FFFD,
             0x30000...0x3FFFD, 0x40000...0x4FFFD : return true

        case 0x50000...0x5FFFD, 0x60000...0x6FFFD,
             0x70000...0x7FFFD, 0x80000...0x8FFFD : return true

        case 0x90000...0x9FFFD, 0xA0000...0xAFFFD,
             0xB0000...0xBFFFD, 0xC0000...0xCFFFD : return true

        case 0xD0000...0xDFFFD, 0xE0000...0xEFFFD : return true

        default                                   : return false
    }
}

func isIdentifierCharacter(_ scalar: Scalar) -> Bool
{
    switch scalar.value
    {
        case _ where isIdentifierHead(scalar) : return true
        case 0x0041...0x005A                  : return true
        case _ where isDigit(scalar)          : return true
        case 0x0300...0x036F, 0x1DC0...0x1DFF,
             0x20D0...0x20FF, 0xFE20...0xFE2F : return true
        default                               : return false
    }
}

func isDigit(_ scalar: Scalar) -> Bool
{
    let value = scalar.value

    return 0x0030 <= value && value <= 0x0039
}

func isHexDigit(_ scalar: Scalar) -> Bool
{
    let value = scalar.value

    switch value
    {
    case _ where isDigit(scalar) : return true
    case 0x0041...0x0046         : return true
    default                      : return false
    }

}

func isStringTerminator(_ scalar: Scalar) -> Bool
{
    switch scalar
    {
        case "\""                        : return true
        case _ where isLinebreak(scalar) : return true
        default                          : return false
    }
}

func isStandardSetHead(_ scalar: Scalar) -> Bool
{
    return scalar.value == 0x0055 || scalar.value == 0x002E
    /*
     *switch scalar.value
     *{
     *    [>case 0x0041...0x005A : return true<]
     *    default              : return false
     *}
     */
}
