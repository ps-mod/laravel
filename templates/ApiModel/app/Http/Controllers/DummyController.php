<?php

namespace App\Http\Controllers;

use App\Http\Requests\DummyRequest;
use App\Http\Requests\DummyUpdateRequest;
use App\Http\Resources\DummyResource;
use App\Models\Dummy;
use App\Utils\Bouncer;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Symfony\Component\HttpFoundation\Response as ResponseCode;

class DummyController extends Controller
{
    public function index(): AnonymousResourceCollection
    {
        return DummyResource::collection(Dummy::all());
    }

    public function store(DummyRequest $request)
    {
        $dummy = Dummy::create($request->validated());
        return response(DummyResource::make($dummy), ResponseCode::HTTP_CREATED);
    }

    public function show(Dummy $dummy): DummyResource
    {
        return DummyResource::make($dummy);
    }

    public function update(DummyUpdateRequest $request, Dummy $dummy): JsonResponse
    {
        $dummy->update($request->validated());
        $dummy->save();
        return response()->json('', ResponseCode::HTTP_NO_CONTENT);
    }

    public function destroy(Dummy $dummy): JsonResponse
    {
        return Bouncer::TryDelete(Dummy::class, $dummy);
    }
}
