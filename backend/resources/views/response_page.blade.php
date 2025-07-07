<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>We got you !</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
</head>

<body class="d-flex vw-100 justify-content-center">
    <div class="container bg-light border border-grey rounded rounded-3 mx-5 px-3 py-4 mt-5" >
        <h4>
            @if ($success)
            <span class="text-success">You request is processed successfully</span>
            @else
            <span class="text-danger">Process Failed</span>
            @endif
        </h4>
        <div class="mb-3"></div>
        @if (is_array($message))
        @foreach ($message as $key=>$value )
        <div class="div"><button class="btn btn-outline-primary">{{ $key }}</button> <button class="btn btn-outline-primary">{{ $value }}</button></div>
        @endforeach
        @else
        <div class="container bg-dark text-white py-3 py-3 rounded">
            <pre>{{ $message }}</pre>    
        </div>
        @endif
    
    </div>
   

</body>

</html>