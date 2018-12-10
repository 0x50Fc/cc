

export interface GetLocationResult {

}

export interface GetLocationObject {
    type:string
    altitude:string
    success:(res:GetLocationResult)=>void
    fail:(err:string)=>void
    complete:()=>void
}

export declare function getLocation(object:GetLocationObject):void;