<?php

namespace Http\Controllers;

use App\Http\Resources\DummyResource;
use App\Models\Dummy;
use Tests\TestCase;

class DummyControllerTest extends TestCase
{
    public function testDummyIndex(): void
    {
        $this->assertModel('dummy.index', DummyResource::make(Dummy::first()), [], Dummy::count());
    }

    public function testDummyShow(): void
    {
        $this->assertModel('dummy.show', DummyResource::make(Dummy::first()), ['dummy' => Dummy::first()->id]);
    }

    public function testDummyCreate(): void
    {
        $this->withoutExceptionHandling();
        $requestModel = [
            'name' => 'Test Dummy',
            //TODO: Complete definition
        ];

        $this->assertPermissionCanCreate('admin', 'dummy', $requestModel, $requestModel);
    }

    public function testDummyUpdate(): void
    {
        $this->assertPermissionCanUpdate('admin', 'dummy', ['name' => 'Updated Dummy'], Dummy::latestOne());
    }

    public function testDummyDelete(): void
    {
        $this->assertPermissionCanDelete('admin', 'dummy', Dummy::first());
    }
}
