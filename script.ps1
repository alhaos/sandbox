class foo {
    $array = (1, 2, 3, 4, 5, 6)

    TurnSmallRight (){
        $buffer = 0
        $buffer = $this.array[0]
        $this.array[0] = $this.array[2]
        $this.array[2] = $this.array[1]
        $this.array[1] = $buffer
    }

    TurnSmallLeft (){
        $buffer = $this.array[0]
        $this.array[0] = $this.array[1]
        $this.array[1] = $this.array[2]
        $this.array[2] = $buffer
    }
    
    TurnBigLeft (){
        $buffer = $this.array[2]
        $this.array[2] = $this.array[3]
        $this.array[3] = $this.array[4]
        $this.array[4] = $this.array[5]
        $this.array[5] = $buffer
    }
    
    TurnBigRight (){
        $buffer = $this.array[2]
        $this.array[2] = $this.array[5]
        $this.array[5] = $this.array[4]
        $this.array[4] = $this.array[3]
        $this.array[3] = $buffer
    }
    
    Print(){
        write-host ("-------" -f $this.array[1,3])
        write-host ("{0} {1}" -f $this.array[1,3])
        write-host (" {0} {1}" -f $this.array[2,4])
        write-host ("{0} {1}" -f $this.array[0,5])
    }
}


# м>б>б>м>б>

$foo = [foo]::new()
$foo.Print()
$foo.TurnSmallRight()
$foo.Print()
$foo.TurnBigRight()
$foo.Print()
$foo.TurnBigRight()
$foo.Print()
$foo.TurnSmallRight()
$foo.Print()
$foo.TurnBigRight()
$foo.Print()

