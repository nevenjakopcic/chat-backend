package hr.nevenjakopcic.chatbackend.model;

public enum RelationshipStatuses {
    INVALID,
    PENDING_FIRST_SECOND,
    PENDING_SECOND_FIRST,
    FRIENDS,
    BLOCK_FIRST_SECOND,
    BLOCK_SECOND_FIRST,
    BLOCK_BOTH
}
