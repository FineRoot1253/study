# 2741 [golang]

```go
package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	var rows int
	reader := bufio.NewReader(os.Stdin)
	writer := bufio.NewWriter(os.Stdout)
	fmt.Fscanln(reader, &rows)


	for i := 1; i <= rows; i++ {
		fmt.Fprintln(writer, i)
	}
	writer.Flush()

}
```

fmt 보단 bufio가 더 읽고 쓰는 능력은 좋다

한번에 읽고 한번에 쓰기 때문이다.
